class PsuCseLogin < Formula
  desc "Login helper for PSU CSE students"
  homepage "https://github.com/Seancheey/psu-cse-login"
  url "https://github.com/Seancheey/psu-cse-login/archive/0.4.tar.gz"
  sha256 "1b2c50060140f3cdcece908363dc429c7a259ca954eb433640019ec88359c53e"
  head "https://github.com/Seancheey/psu-cse-login.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ace13b3bc548bb6ac89b1cdc591fec4df726cc1026faaa93f48ccd57abdf0f59" => :mojave
    sha256 "ace13b3bc548bb6ac89b1cdc591fec4df726cc1026faaa93f48ccd57abdf0f59" => :high_sierra
    sha256 "0d21c65de77c5fe195673795237b6e8c779e860ad510195d5c7cce460a469f59" => :sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_predicate bin/"cse-login", :exist?
  end
end
