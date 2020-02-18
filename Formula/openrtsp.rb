class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2020.02.11.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "df105ad85cdcf88c56ea669733273bb1c41c5148469ee1e43b6396e24f66bfde"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c9ed5238e76d700d4d0da643d825be51fb2fc567b8fb90d41d60c484a40c08c" => :catalina
  end

  depends_on "openssl@1.1"

  def install
    system "./genMakefiles", "macosx"
    system "make", "PREFIX=#{prefix}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats; <<~EOS
    Testing executables have been placed in:
      #{libexec}
  EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
