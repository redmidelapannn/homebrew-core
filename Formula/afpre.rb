class Afpre < Formula
  desc "CLI for the AWS Federation Proxy"
  homepage "https://github.com/leflamm/afpre"
  url "https://github.com/leflamm/afpre/archive/0.9.9.tar.gz"
  sha256 "793ae1e8bb8c98ba4d6e3b21aa150a3dabefbd9ebd69a935495dd58c0305319c"

  head "https://github.com/leflamm/afpre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5390b2b681113cf028299535cf70c770a8162f551587e7834d7f0a76632c28f0" => :sierra
    sha256 "5390b2b681113cf028299535cf70c770a8162f551587e7834d7f0a76632c28f0" => :el_capitan
  end

  depends_on "jq"

  def install
    bin.install "afpre"
    chmod 0555, bin/"afpre"
  end

  test do
    system "true"
  end
end
