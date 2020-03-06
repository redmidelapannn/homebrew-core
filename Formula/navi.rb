class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.0.0.tar.gz"
  sha256 "de63659887e0fd074543917b492b8f7fdb465c8001efae40f736468dd5def6c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "b27df657a49f90b34a6fcb95d84132b2fedd447c7b6210c76a7aab7369645ce7" => :catalina
    sha256 "560d7ce10281e159ff6b6585efd787ed0bbb06ccbc7697787a9707c4d869f0c6" => :mojave
    sha256 "14ff6d1d39812e371a7c0f97e5210e2f833b8e49c7ab940133475d1572f3db5b" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    # copy resources
    libexec.install Dir["cheats/*"]
    libexec.install Dir["shell/*"]

    # build binary
    system "cargo", "install", "--root", prefix, "--path", "."

    # make sure the binary is in the same folder as the resources
    mv "#{bin}/navi", "#{libexec}/navi"
    ln_s "#{libexec}/navi", "#{bin}/navi"
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")

    (testpath/"cheats/test.cheat").write <<~EOS
      % test

      # foo
      echo "bar"

      # lorem
      echo "ipsum"
    EOS

    assert_match "bar", shell_output("#{bin}/navi --path #{testpath}/cheats best foo")
  end
end
