class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz"
  sha256 "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf"
  revision 1

  bottle do
    cellar :any
    sha256 "29392f96935748355b829b5612ebeed3f8fcb09b713059afec7d2bfc2eb33e96" => :mojave
    sha256 "bcfd789a7ea95a1cdd894530ed81447509637ddc5eaedd170f0add7b55ce1d3e" => :high_sierra
    sha256 "cf9fd9dca9b8966b981b097ed0be928096f4e1491bebe1f293be1a5c13f2f556" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "buildroot" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include "gflags/gflags.h"

      DEFINE_bool(verbose, false, "Display program name before message");
      DEFINE_string(message, "Hello world!", "Message to print");

      static bool IsNonEmptyMessage(const char *flagname, const std::string &value)
      {
        return value[0] != '\0';
      }
      DEFINE_validator(message, &IsNonEmptyMessage);

      int main(int argc, char *argv[])
      {
        gflags::SetUsageMessage("some usage message");
        gflags::SetVersionString("1.0.0");
        gflags::ParseCommandLineFlags(&argc, &argv, true);
        if (FLAGS_verbose) std::cout << gflags::ProgramInvocationShortName() << ": ";
        std::cout << FLAGS_message;
        gflags::ShutDownCommandLineFlags();
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lgflags", "test.cpp", "-o", "test"
    assert_match "Hello world!", shell_output("./test")
    assert_match "Foo bar!", shell_output("./test --message='Foo bar!'")
  end
end
