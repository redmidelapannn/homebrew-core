class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "http://eprover.org"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_1.9/E.tgz"
  sha256 "c4365661a6a4519b21b895fafe60c6b39b8acadf77a3c42e4d638027f155376e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ff27bc6b0512e8f1a7d414a7f036a78615655ad8f8fd55daf4f154fb3b35ca66" => :sierra
    sha256 "6c43e488e3358099798b93061d26e1c4bf9e4656ce5ddcd36710b0f1c19da752" => :el_capitan
    sha256 "f5cb05d543907d70d1181fd8d2a876f998963075b3439fd2d2f956743cadf7c7" => :yosemite
  end

  def install
    system "./configure", "--bindir=#{bin}", "--man-prefix=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/eproof"
  end
end
