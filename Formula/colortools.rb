class Colortools < Formula
  desc "Convert, import and export MacOS Color Picker (NSColorList) palettes"
  homepage "https://github.com/ramonpoca/ColorTools"
  url "https://github.com/ramonpoca/ColorTools/archive/0.2.tar.gz"
  sha256 "87fe9a8ba6edd1bebf697f9f821f15f2073b29825fa18ea68e77f5ccb2a7f3e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ac47c77e690641a9904979938e3ad5e7a51c6f4e48d8b1588f60fd73edd2657" => :sierra
    sha256 "f38cf066fef3ceae13735296aed0592959c3e900318e16d79978c7350a5f4836" => :el_capitan
    sha256 "bee62a27d6375f337992b533f41d4818364171ff594f6e07972e4111945ada8a" => :yosemite
  end

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/Ase2Clr" => "ase2clr"
    bin.install "build/Release/Clr2Ase" => "clr2ase"
    bin.install "build/Release/Clr2Obj" => "clr2obj"
    bin.install "build/Release/Html2Clr" => "html2clr"
  end

  test do
    # "foo --version and foo --help are bad tests. However, a bad test is better
    # than no test at all"
    #  - https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
    program_should_run_and_print_usage "ase2clr"
    program_should_run_and_print_usage "clr2ase"
    program_should_run_and_print_usage "clr2obj"
    program_should_run_and_print_usage "html2clr"
  end

  private

  def program_should_run_and_print_usage(cmd)
    assert_match "Usage:", shell_output("#{bin}/#{cmd} 2>&1 | grep Usage")
  end
end
