#./build_tnntorch_linux/test/TNNTest -mp /mount/trained_vgg16_qat.jit.pt -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,224,224"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /mount/trained_resnet50_qat.jit.pt -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,300,300"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /mount/centernet_backbone_qat.pt -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,320,320"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /mount/centernet_backbone_part_qat.pt -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#nsys profile -f true -o resnet_nv_qat.qdstrm ./build_tnntorch_linux/test/TNNTest -ic 100 -mp /root/models/resnet50_nv_qat.pt -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,300,300"  2>&1 | tee log.txt
#nsys profile -f true -o resnet_qat.qdstrm ./build_tnntorch_linux/test/TNNTest -ic 100 -mp /root/models/trained_resnet50_qat.jit.pt -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,300,300"  2>&1 | tee log.txt
#nsys profile -f true -o centernet_backbone.qdstrm ./build_tnntorch_linux/test/TNNTest -ic 100 -pr LOW -mp /root/models/centernet_backbone.pt -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
nsys profile -f true -o model_20_normal.qdrep \
./build_tnntorch_linux/test/TNNTest -mp /data/models/model_20.pt -pr NORMAL -wc 20 -ic 40 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /data/jinghao/centernet_logo/models/model_20_5xlr.pt -pr NORMAL -wc 20 -ic 40 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
