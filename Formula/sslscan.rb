class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.6-rbsec.tar.gz"
  version "1.11.6"
  sha256 "18932a78ad968dc5859b8cc72c84e64a46367887eb9302eaf13069bb9da1e08d"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "02b3cd92a8fecbbaa95adfeee7c2efb6b05c3e60d1c2ebbcaf7d632c1c8504d3" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "make"
    bin.install "sslscan"
    man1.install "sslscan.1"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
