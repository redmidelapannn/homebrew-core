class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.2.0.tar.xz"
  sha256 "4e94583a373965821805e665e0a05f52fb610916676edb09148941415637c575"

  bottle do
    cellar :any_skip_relocation
    sha256 "caf5bf66a6188ce1f9b905d1365cdb4a5fb7054183b9c82faaf6df9732146dcf" => :catalina
    sha256 "7bf41195bc8103b68f8771deefe2760ba78353b5f53b8ce27ecfeb7be5cf19aa" => :mojave
    sha256 "3532d7426c7f87cd205ee517d2a728f297f6381df1212ec1982c86fa94c6ccfb" => :high_sierra
  end

  head do
    url "https://github.com/nim-lang/Nim.git", :branch => "devel"
    resource "csources" do
      url "https://github.com/nim-lang/csources.git"
    end
  end

  def install
    if build.head?
      resource("csources").stage do
        system "/bin/sh", "build.sh"
        (buildpath/"bin").install "bin/nim"
      end
    else
      system "/bin/sh", "build.sh"
    end
    # Compile the koch management tool
    system "bin/nim", "c", "-d:release", "koch"
    # Build a new version of the compiler with readline bindings
    system "./koch", "boot", "-d:release", "-d:useLinenoise"
    # Build nimble/nimgrep/nimpretty/nimsuggest
    system "./koch", "tools"
    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest]
    tools.each do |t|
      target.install buildpath/"bin"/t
      bin.install_symlink target/t
    end
  end

  test do
    (testpath/"hello.nim").write <<~EOS
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<~EOS
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end
