// Tencent is pleased to support the open source community by making TNN available.
//
// Copyright (C) 2020 THL A29 Limited, a Tencent company. All rights reserved.
//
// Licensed under the BSD 3-Clause License (the "License"); you may not use this file except
// in compliance with the License. You may obtain a copy of the License at
//
// https://opensource.org/licenses/BSD-3-Clause
//
// Unless required by applicable law or agreed to in writing, software distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

#ifndef TNN_SOURCE_TNN_TRAIN_GRADIENT_LAYER_GRAD_H
#define TNN_SOURCE_TNN_TRAIN_GRADIENT_LAYER_GRAD_H

#include <map>
#include <string>

#include "tnn/core/blob.h"
#include "tnn/core/status.h"
#include "tnn/layer/base_layer.h"
#include "tnn/train/training_info.h"
#include "tnn/utils/dims_function_utils.h"
#include "tnn/utils/omp_utils.h"

namespace TNN_NS {

class LayerGrad {
public:
    LayerGrad();

    virtual ~LayerGrad();

    virtual Status OnGrad(const std::vector<Blob *> &inputs, const std::vector<Blob *> &outputs,
                          LayerResource *resource, LayerParam *param, Context *context,
                          const LayerGradInfo &grad_info) = 0;

    static Status RegisterLayerGrad(DeviceType device, LayerType type, std::shared_ptr<LayerGrad> layer_grad);

    static LayerGrad *GetLayerGrad(DeviceType device, LayerType type);

private:
    static std::map<std::pair<DeviceType, LayerType>, std::shared_ptr<LayerGrad>> &GetLayerGradMap();
};

template <typename T>
class LayerGradRegister {
public:
    explicit LayerGradRegister(DeviceType device, LayerType type) {
        LayerGrad::RegisterLayerGrad(device, type, std::make_shared<T>());
    }
};

#define DECLARE_LAYER_GRAD(device_string, device, type_string, layer_type)                                             \
    class device_string##type_string##LayerGrad : public LayerGrad {                                                   \
    public:                                                                                                            \
        virtual ~device_string##type_string##LayerGrad(){};                                                            \
        virtual Status OnGrad(const std::vector<Blob *> &inputs, const std::vector<Blob *> &outputs,                   \
                              LayerResource *resource, LayerParam *param, Context *context,                            \
                              const LayerGradInfo &grad_info);                                                         \
    };

#define REGISTER_LAYER_GRAD(device_string, device, type_string, layer_type)                                            \
    LayerGradRegister<device_string##type_string##LayerGrad> g_##device##_##layer_type##_layer_grad_register(          \
        device, layer_type);

#define PREPARE_INPUT_AND_GRAD(I)                                                                                      \
    std::vector<Blob *> fw_inputs(inputs.begin(), inputs.begin() + I);                                                 \
    std::vector<Blob *> input_grads(outputs.begin(), outputs.begin() + I);                                             \
    const std::vector<bool> &acc_input_grads = grad_info.accumulate_input_grad;                                        \
    std::vector<DimsVector> input_dims;                                                                                \
    for (int i = 0; i < I; ++i) {                                                                                      \
        input_dims.push_back(fw_inputs[i]->GetBlobDesc().dims);                                                        \
        auto input_grad_dims = input_grads[i]->GetBlobDesc().dims;                                                     \
        if (!DimsVectorUtils::Equal(input_dims[i], input_grad_dims)) {                                                 \
            LOGE("LayerGrad::OnGrad %s vs %s: , dims not match\n", fw_inputs[i]->GetBlobDesc().description().c_str(),  \
                 input_grads[i]->GetBlobDesc().description().c_str());                                                 \
            return Status(TNNERR_LAYER_ERR, "LayerGrad::OnGrad input and input_grad dims not match");                  \
        }                                                                                                              \
    }

#define PREPARE_OUTPUT_AND_GRAD(I, O)                                                                                  \
    std::vector<Blob *> fw_outputs(inputs.begin() + I, inputs.begin() + I + O);                                        \
    std::vector<Blob *> output_grads(inputs.begin() + I + O, inputs.begin() + I + O * 2);                              \
    std::vector<DimsVector> output_dims;                                                                               \
    for (int i = 0; i < O; ++i) {                                                                                      \
        output_dims.push_back(fw_outputs[i]->GetBlobDesc().dims);                                                      \
        auto output_grad_dims = output_grads[i]->GetBlobDesc().dims;                                                   \
        if (!DimsVectorUtils::Equal(output_dims[i], output_grad_dims)) {                                               \
            LOGE("LayerGrad::OnGrad %s vs %s: , dims not match\n", fw_outputs[i]->GetBlobDesc().description().c_str(), \
                 output_grads[i]->GetBlobDesc().description().c_str());                                                \
            return Status(TNNERR_LAYER_ERR, "LayerGrad::OnGrad output and output_grad dims not match");                \
        }                                                                                                              \
    }

#define PREPARE_RESOURCE_AND_GRAD(I, R)                                                                                \
    std::vector<RawBuffer *> fw_resources;                                                                             \
    if (R > 0) {                                                                                                       \
        fw_resources = resource->GetTrainable();                                                                       \
    }                                                                                                                  \
    std::vector<Blob *> resource_grads(outputs.begin() + I, outputs.begin() + I + R);                                  \
    const std::vector<bool> &acc_resource_grads = grad_info.accumulate_resource_grad;                                  \
    std::vector<DimsVector> resource_dims;                                                                             \
    for (int i = 0; i < R; ++i) {                                                                                      \
        resource_dims.push_back(resource_grads[i]->GetBlobDesc().dims);                                                \
        auto resource_count = fw_resources[i]->GetDataCount();                                                         \
        if (resource_count > 0 && DimsVectorUtils::Count(resource_dims[i]) != resource_count) {                        \
            LOGE("LayerGrad::OnGrad %d vs %s: , dims not match\n", resource_count,                                     \
                 resource_grads[i]->GetBlobDesc().description().c_str());                                              \
            return Status(TNNERR_LAYER_ERR, "LayerGrad::OnGrad resource and resource_grad data count not match");      \
        }                                                                                                              \
    }

// IOR: input, output and resource counts
#define ON_GRAD_PREPARATION_IOR(I, O, R)                                                                               \
    if (inputs.size() != ((I) + (O)*2) || outputs.size() != (I) + (R)) {                                               \
        LOGE(                                                                                                          \
            "LayerGrad::OnGrad, input or output size error, input %d vs expected %d + %d, output %d vs expected %d + " \
            "%d\n",                                                                                                    \
            int(inputs.size()), (I), (O)*2, int(outputs.size()), (I), (R));                                            \
        return Status(TNNERR_TRAIN_ERROR, "input or output size error");                                               \
    }                                                                                                                  \
    if ((R) > 0 && resource->GetTrainable().size() != (R)) {                                                           \
        LOGE("LayerGrad::OnGrad, trainable size error\n");                                                             \
        return Status(TNNERR_TRAIN_ERROR, "trainable size error");                                                     \
    }                                                                                                                  \
    if (grad_info.accumulate_input_grad.size() != (I)) {                                                               \
        LOGE("LayerGrad::OnGrad, accumulate_input_grad size error\n");                                                 \
        return Status(TNNERR_TRAIN_ERROR, "accumulate_input_grad size error");                                         \
    }                                                                                                                  \
    if (grad_info.accumulate_resource_grad.size() != (R)) {                                                            \
        LOGE("LayerGrad::OnGrad, accumulate_resource_grad size error\n");                                              \
        return Status(TNNERR_TRAIN_ERROR, "accumulate_resource_grad size error");                                      \
    }                                                                                                                  \
    PREPARE_INPUT_AND_GRAD((I));                                                                                       \
    PREPARE_OUTPUT_AND_GRAD((I), (O));                                                                                 \
    PREPARE_RESOURCE_AND_GRAD((I), (R));

}  // namespace TNN_NS

#endif  // TNN_SOURCE_TNN_TRAIN_GRADIENT_LAYER_GRAD_H