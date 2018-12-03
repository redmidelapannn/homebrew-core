class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "http://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.2/E.tgz"
  sha256 "2c2c45a57e69daa571307a89746228194f0144a5884741f2d487823f1fbf3022"

  bottle do
    cellar :any_skip_relocation
    sha256 "432ce56302df8caefa7f178d3ecfa7048d5bd800e589cf12f86486f0939e1cf8" => :mojave
    sha256 "ce17c65433437794dd5b76d9483e5cd8fa486495e813559a32c19d8f7280242c" => :high_sierra
    sha256 "ab6ef6354e9356f31b0deb0bc7812394ba48e5cc85f55dc2ca0afc4e32280d79" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end
