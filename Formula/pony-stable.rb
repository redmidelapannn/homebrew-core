class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.2.1.tar.gz"
  sha256 "1335d7b3457421b8913f19c17da76d2d6b9ad17288dfb5fdcf2af9fd93193890"
  head "https://github.com/ponylang/pony-stable.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c40f7c807e4ae56bee9681bd9b7c524ab491745e94d6955a48431f7bd5926f55" => :catalina
    sha256 "c40f7c807e4ae56bee9681bd9b7c524ab491745e94d6955a48431f7bd5926f55" => :mojave
    sha256 "7e9fe537d567fd28dd94b5b451b7f4109eb14f462e6882a21e5d722c808352fe" => :high_sierra
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
    system "#{bin}/stable", "env", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
