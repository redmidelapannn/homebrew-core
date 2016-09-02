class Jam < Formula
  desc "Make-like build tool"
  homepage "https://www.perforce.com/resources/documentation/jam"
  url "https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/jam-2.6.zip"
  sha256 "7c510be24dc9d0912886c4364dc17a013e042408386f6b937e30bd9928d5223c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3d4071fe1ec9ed485bb448cc0bc1366dada9fab55bec1bc4f2fc13c5171d8c39" => :el_capitan
    sha256 "17a4afcc31f78c1fe1a9897c62a5f7aacda87bd0095bdfaa38851052de0ab160" => :yosemite
    sha256 "6bccc9dbba8dcca83edc40585475f7c902f7ccce12755c71553531a629d4136d" => :mavericks
  end

  conflicts_with "ftjam", :because => "both install a `jam` binary"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LOCATE_TARGET=bin"
    bin.install "bin/jam", "bin/mkjambase"
  end

  test do
    (testpath/"Jamfile").write <<-EOS.undent
      Main jamtest : jamtest.c ;
    EOS

    (testpath/"jamtest.c").write <<-EOS.undent
      #include <stdio.h>

      int main(void)
      {
          printf("Jam Test\\n");
          return 0;
      }
    EOS

    assert_match /Cc jamtest.o/, shell_output(bin/"jam").strip
    assert_equal "Jam Test", shell_output("./jamtest").strip
  end
end
