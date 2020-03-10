class Oclgrind < Formula
  desc "OpenCL device simulator and debugger"
  homepage "https://github.com/jrprice/Oclgrind"
  url "https://github.com/jrprice/Oclgrind/archive/v19.10.tar.gz"
  sha256 "f9a8f22cb9f6d88670f2578c46ba0d728ba8eaee5c481c2811129dc157c43dc0"

  bottle do
    cellar :any
    rebuild 2
    sha256 "5d9d55b0be357c191345dc7dd670783dd7853af9f08f6697e991949d0bf5c179" => :catalina
    sha256 "f7e73f3101c823fb8e67e03917646f0544a96192e35e7f3d656f177485619257" => :mojave
    sha256 "f7b42cacd9846677462626bb14866accfbe851ff50e17b99d429e19b919fa7cc" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"rot13.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>

      #include <OpenCL/cl.h>

      const char rot13_cl[] = "                         \
      __kernel void rot13                               \
          (   __global    const   char*    in           \
          ,   __global            char*    out          \
          )                                             \
      {                                                 \
          const uint index = get_global_id(0);          \
                                                        \
          char c=in[index];                             \
          if (c<'A' || c>'z' || (c>'Z' && c<'a')) {     \
              out[index] = in[index];                   \
          } else {                                      \
              if (c>'m' || (c>'M' && c<'a')) {          \
                out[index] = in[index]-13;              \
              } else {                                  \
                out[index] = in[index]+13;              \
              }                                         \
          }                                             \
      }                                                 \
      ";

      void rot13 (char *buf) {
        int index=0;
        char c=buf[index];
        while (c!=0) {
          if (c<'A' || c>'z' || (c>'Z' && c<'a')) {
            buf[index] = buf[index];
          } else {
            if (c>'m' || (c>'M' && c<'a')) {
              buf[index] = buf[index]-13;
            } else {
              buf[index] = buf[index]+13;
            }
          }
          c=buf[++index];
        }
      }

      int main() {
        char buf[]="Hello, World!";
        size_t srcsize, worksize=strlen(buf);

        cl_int error;
        cl_platform_id platform;
        cl_device_id device;
        cl_uint platforms, devices;

        error=clGetPlatformIDs(1, &platform, &platforms);
        error=clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, 1, &device, &devices);
        cl_context_properties properties[]={
                CL_CONTEXT_PLATFORM, (cl_context_properties)platform,
                0};

        cl_context context=clCreateContext(properties, 1, &device, NULL, NULL, &error);
        cl_command_queue cq = clCreateCommandQueue(context, device, 0, &error);

        rot13(buf);

        const char *src=rot13_cl;
        srcsize=strlen(rot13_cl);

        const char *srcptr[]={src};
        cl_program prog=clCreateProgramWithSource(context,
                1, srcptr, &srcsize, &error);
        error=clBuildProgram(prog, 0, NULL, "", NULL, NULL);

        cl_mem mem1, mem2;
        mem1=clCreateBuffer(context, CL_MEM_READ_ONLY, worksize, NULL, &error);
        mem2=clCreateBuffer(context, CL_MEM_WRITE_ONLY, worksize, NULL, &error);

        cl_kernel k_rot13=clCreateKernel(prog, "rot13", &error);
        clSetKernelArg(k_rot13, 0, sizeof(mem1), &mem1);
        clSetKernelArg(k_rot13, 1, sizeof(mem2), &mem2);

        char buf2[sizeof buf];
        buf2[0]='?';
        buf2[worksize]=0;

        error=clEnqueueWriteBuffer(cq, mem1, CL_FALSE, 0, worksize, buf, 0, NULL, NULL);
        error=clEnqueueNDRangeKernel(cq, k_rot13, 1, NULL, &worksize, &worksize, 0, NULL, NULL);
        error=clEnqueueReadBuffer(cq, mem2, CL_FALSE, 0, worksize, buf2, 0, NULL, NULL);
        error=clFinish(cq);

        puts(buf2);
      }
    EOS

    system ENV.cc, "rot13.c", "-o", "rot13", "-framework", "OpenCL"
    output = shell_output("#{bin}/oclgrind ./rot13 2>&1").chomp
    assert_equal "Hello, World!", output
  end
end
