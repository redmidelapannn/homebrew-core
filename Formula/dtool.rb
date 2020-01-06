class Dtool < Formula
  desc "Command-line tool collection to assist development"
  homepage "https://github.com/guoxbin/dtool"
  url "https://github.com/guoxbin/dtool/releases/download/v0.4.0/dtool-mac.tar.gz"
  version "0.4.0"
  sha256 "98ee2948fa959cf53700873a1e8fc5473a72fb3d9dec41725f42bd3a8803e0e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "aebee0845b60a2cb7e6215aa34410fb6ae221df5714091795319cf546747565d" => :high_sierra
  end

  def install
    bin.install "dtool"
  end

  test do
    assert_match "0x61626364", shell_output("#{bin}/dtool s2h abcd")
  end
end
