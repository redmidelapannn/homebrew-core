class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.3.0.tar.gz"
  sha256 "5e2f825dd67a060623bdbd992bcdf2d4a377a6d491f4bd60e8754f60df33e578"
  head "https://github.com/ponylang/corral.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e3c821342ad08745e7e0b529d9de38dab6ae57df390af81ccb4b850943a21d33" => :catalina
    sha256 "e3c821342ad08745e7e0b529d9de38dab6ae57df390af81ccb4b850943a21d33" => :mojave
    sha256 "11c344e61b9c5afc5d7f575bd145b2529e6810f2b5d19467fc9b466116daf484" => :high_sierra
  end

  depends_on "ponyc"

  def install
    system "make", "arch=x86-64", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
