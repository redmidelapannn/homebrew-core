class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "http://nim-lang.org/"
  url "http://nim-lang.org/download/nim-0.15.0.tar.xz"
  sha256 "c514535050b2b2156147bbe6e23aafe07cd996b2afa2c81fa9a09e1cd8c669fb"
  head "https://github.com/nim-lang/Nim.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "fb64091411aee902cf64bea0f2fa6f15d12610c43748792a3e9fd93e8427b552" => :sierra
    sha256 "8306156f5e55a10f633c10dd8650161c3af2ef060825bbe93318b2e6058a83ee" => :el_capitan
    sha256 "256e6092374aa87c1c9c09e4c6991f4facd125957931661fd17becb3d40e3887" => :yosemite
  end

  resource "nimble" do
    url "https://github.com/nim-lang/nimble/archive/v0.7.10.tar.gz"
    sha256 "9fc4a5eb4a294697e530fe05e6e16cc25a1515343df24270c5344adf03bd5cbb"
  end

  resource "nimsuggest" do
    url "https://github.com/nim-lang/nimsuggest/archive/1bf26419e84fab2bbefe8e11910b16f8f6c8a758.tar.gz"
    sha256 "87c78998f185f8541255b0999dfe4af3a1edcc59e063818efd1b6ca157d18315"
  end

  def install
    if build.head?
      system "/bin/sh", "bootstrap.sh"

      # Grab the tools source and put them in the dist folder
      nimble = buildpath/"dist/nimble"
      resource("nimble").stage { nimble.install Dir["*"] }
      nimsuggest = buildpath/"dist/nimsuggest"
      resource("nimsuggest").stage { nimsuggest.install Dir["*"] }
    else
      system "/bin/sh", "build.sh"
    end
    system "/bin/sh", "install.sh", prefix

    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"

    system "bin/nim", "e", "install_tools.nims"
    target = prefix/"nim/bin"
    target.install "dist/nimble/src/nimblepkg"
    target.install "bin/nimsuggest"
    target.install "bin/nimble"
    target.install "bin/nimgrep"
    bin.install_symlink prefix/"nim/bin/nimsuggest"
    bin.install_symlink target/"nimble"
    bin.install_symlink target/"nimgrep"
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
