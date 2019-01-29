class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "http://libpipeline.nongnu.org/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.1.tar.gz"
  sha256 "d633706b7d845f08b42bc66ddbe845d57e726bf89298e2cee29f09577e2f902f"

  bottle do
    cellar :any
    sha256 "ab420abd51374fa093179566ed0fca4cfe83306cedd9ec3027f22d42a7e7e066" => :mojave
    sha256 "595a6803077f7f30268523cd8c8d0b9dc3d1ef26d4939a1fd247d4ee4b193333" => :high_sierra
    sha256 "2fec168915b15541fc44e0c0faee8e48c4d78e269d93496e2a6ed7f249ddf780" => :sierra
  end

  depends_on "pkg-config"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdint.h>
      #include <pipeline.h>
      int main(void)
      {
        pipeline *p = pipeline_new_command_args("true", NULL);
        int status = pipeline_run(p);
        return status;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lpipeline", "-I#{include}", "-o", "test"
    system "./test"
  end
end
