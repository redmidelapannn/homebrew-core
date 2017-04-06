class CsvFix < Formula
  desc "Tool for manipulating CSV data."
  homepage "https://neilb.bitbucket.io/csvfix/"
  url "https://bitbucket.org/neilb/csvfix/get/version-1.6.tar.gz"
  sha256 "32982aa0daa933140e1ea5a667fb71d8adc731cc96068de3a8e83815be62c52b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "84cc64453a80a8d9a4ae7b8d080354ea0be5f0a409faf5fa669dd7cb4f8c2fa2" => :sierra
    sha256 "207d7f04523eda689d89e9ecb8c7d334e33a5a03f21bdaff7273701863892af7" => :el_capitan
    sha256 "6006be0ef31450b729aef11a86685081ea37016c8a3414fdca2b955ab8978b20" => :yosemite
  end

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    system "make", "lin"
    bin.install "csvfix/bin/csvfix"
  end

  test do
    assert_equal '"foo","bar"',
                 pipe_output("#{bin}/csvfix trim", "foo , bar \n").chomp
  end
end
