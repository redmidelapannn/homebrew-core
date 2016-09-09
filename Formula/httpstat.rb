class Httpstat < Formula
  desc "Curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/v1.1.2.tar.gz"
  sha256 "0468abebfbae9ff7ea35d577b60ff9af9db3ff67ffd81b11ac005c4e9602919b"

  bottle do
    cellar :any_skip_relocation
    sha256 "45a6e092d6a35c651a12d7b81a85c9c47c82a4d19d9968f8b1bbfe4216455541" => :el_capitan
    sha256 "83d04e76c3c5084746df20f400e85281b554b312bab2bbddd81b2788269bbd26" => :yosemite
    sha256 "83d04e76c3c5084746df20f400e85281b554b312bab2bbddd81b2788269bbd26" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "httpstat.py" => "httpstat"
  end

  test do
    assert_match "HTTP", shell_output("#{bin}/httpstat https://github.com")
  end
end
