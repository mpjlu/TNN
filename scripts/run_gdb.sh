#gdb -args ./build_tnntorch_linux/test/TNNTest  -mp /mount/trained_vgg16_qat.jit.pt -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,224,224"
#gdb -args ./build_tnntorch_linux/test/TNNTest -mp /mount/trained_resnet50_qat.jit.pt -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,224,224"  2>&1 | tee log.txt
#gdb -args ./build_tnntorch_linux/test/TNNTest -mp /mount/centernet_qat.pt -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
gdb -args ./build_tnntorch_linux/test/TNNTest -mp /root/models/centernet_backbone_part_qat.pt -ic 20 -dt CUDA -mt TS -nt TORCH -is "input_0:1,3,768,768"  2>&1 | tee log.txt
