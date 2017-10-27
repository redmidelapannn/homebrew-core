class Mtoc < Formula
  desc "Mach-O to COFF/EFI binarie converter from static binaries"
  homepage "https://opensource.apple.com/source/cctools/cctools-895/"
  url "https://opensource.apple.com/tarballs/cctools/cctools-895.tar.gz"
  sha256 "ce66034fa35117f9ae76bbb7dd72d8068c405778fa42e877e8a13237a10c5cb7"
  bottle do
    cellar :any_skip_relocation
    sha256 "242f8dab060d2471cc083f1bdaba0fb3f7595d29c54eeaf174793d19bd9859d4" => :high_sierra
    sha256 "145616986ecbc57ccee0460fd26de55d9f003b6257b19ec953fcd4c62dbd9d9e" => :sierra
    sha256 "5c0c84bf5d883f7e4b9fc362f5da17876fc1a89fa787c9273e7bbf790327ac5d" => :el_capitan
  end

  depends_on "llvm" => :build

  def install
    disassembler_path = "include/llvm-c/Disassembler.h"

    disassembler_header = File.read(File.join(buildpath, disassembler_path))

    llvm_include = File.join(buildpath, "include")
    llvm_c_include = File.join(buildpath, "include")

    mkdir_p llvm_include
    mkdir_p llvm_c_include

    cp_r "#{HOMEBREW_PREFIX}/opt/llvm/include/llvm", llvm_include
    cp_r "#{HOMEBREW_PREFIX}/opt/llvm/include/llvm-c", llvm_c_include

    File.open(File.join(buildpath, disassembler_path), "w") { |f| f.write(disassembler_header) }

    `make > /dev/null 2>&1`

    Dir.chdir File.join(buildpath, "efitools")

    system "make"

    mkdir_p bin

    cp File.join(buildpath, "efitools/mtoc.NEW"), File.join(bin, "mtoc")
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test mtoc`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "which", "mtoc"
  end
end
