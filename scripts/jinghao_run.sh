#./build_tnntorch_linux/test/TNNTest -mp /mount/trained_resnet50.jit.pt -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,300,300"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /mount/centernet_backbone.pt -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /root/models/centernet_backbone_part_qat.pt -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /root/models/centernet_backbone_qat.pt -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /root/models/centernet_backbone.pt -pr HIGH -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /root/models/resnet50_nv_qat.pt -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,300,300"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /root/models/trained_resnet50.jit.pt -pr NORMAL -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,300,300"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /root/models/trained_resnet50_qat.jit.pt -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,300,300"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /root/models/test_add_noq_relu_opt.pt -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,300,300"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /root/models/trained_centernet_qat.jit.pt -wc 100 -ic 20000 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /root/models/centernet_jinghaofeng_qat.pt -wc 10 -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /data/models/model_20_fix.pt -wc 20 -ic 50 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /data/models/model_20_no_fake.pt -wc 100 -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /data/models/model_20.pt -pr NORMAL -wc 100 -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
./build_tnntorch_linux/test/TNNTest -mp /data/jinghao/centernet_logo/models/model_20_black_last.pt -wc 20 -ic 50 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
#./build_tnntorch_linux/test/TNNTest -mp /data/models/centernet_nv_mode3_calib.pt -pr NORMAL -wc 100 -ic 200 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
