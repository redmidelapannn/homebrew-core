class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "http://nim-lang.org/"
  url "http://nim-lang.org/download/nim-0.15.0.tar.xz"
  sha256 "c514535050b2b2156147bbe6e23aafe07cd996b2afa2c81fa9a09e1cd8c669fb"
  head "https://github.com/nim-lang/Nim.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5198c7cf3b4c1195bdeb1d59343afb6c3c6d06fa5b27e00f68fa9de174a86519" => :sierra
    sha256 "41cf029cc598239e78fee0c6ec180fcf7d1169553a39439201f14c22917f3b98" => :el_capitan
    sha256 "4db3c40e99fdd4c898808e913cbe31076997c450584a24749a06e2255a1df6bb" => :yosemite
  end

  def install
    if build.head?
      system "/bin/sh", "bootstrap.sh"
    else
      system "/bin/sh", "build.sh"
    end
    system "/bin/sh", "install.sh", prefix

    system "bin/nim e install_tools.nims"

    target = prefix/"nim/bin"
    target.install "bin/nimble"
    target.install "dist/nimble/src/nimblepkg"
    target.install "bin/nimgrep"
    target.install "bin/nimsuggest"

    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"
    bin.install_symlink prefix/"nim/bin/nimble"
    bin.install_symlink prefix/"nim/bin/nimgrep"
    bin.install_symlink prefix/"nim/bin/nimsuggest"

  end

  test do
    (testpath/"hello.nim").write <<-EOS.undent
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<-EOS.undent
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"", shell_output("#{bin}/nimble dump").split("\n")[0].chomp
  end
end
