class Tag < Formula
  desc "Manipulate and query tags on Mavericks files"
  homepage "https://github.com/jdberry/tag/"
  url "https://github.com/jdberry/tag/archive/v0.9.tar.gz"
  sha256 "ec2e3df36e18d4bd17f8fea34c1c5b9311e23d220e4ad64fc55505aa4c4b552a"
  head "https://github.com/jdberry/tag.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "48d5bbe872c0cf071d9e28de192d42a6686b816d0fc049c6066db91c983aeb2a" => :mojave
    sha256 "5c53dae53dfcc4824d773284104be7469d2069b923924913b71c23cdbffbfa2b" => :high_sierra
    sha256 "52ca7b393b7a54d7723cb9587ef1131a669accace387f57ff0e69e0fdc4b99e3" => :sierra
  end

  def install
    system "make"
    bin.install "bin/tag"
  end

  test do
    test_tag = "test_tag"
    test_file = Pathname.pwd+"test_file"
    touch test_file
    system "#{bin}/tag", "--add", test_tag, test_file
    assert_equal test_tag, `#{bin}/tag --list --no-name #{test_file}`.chomp
  end
end
