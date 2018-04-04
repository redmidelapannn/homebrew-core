class Oksh < Formula
  desc "The portable version of the OpenBSD Korn shell, a Public Domain shell"
  homepage "https://devio.us/~bcallah/oksh/"
  url "https://devio.us/~bcallah/oksh/oksh-20180111.tar.gz"
  sha256 "c15652b503123dd542144c36f12a076fdb89b1fc4c6a8807ce1ec83fa1e0d797"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a346d39165471a33ab3c555d4f4a7af88bb11b4e2fa4ac28af1330dd6357226" => :high_sierra
    sha256 "19732558a4e7a42fa59b45d11a53c31b68f5f21a803b768664e04c7b36e3244b" => :sierra
    sha256 "617f2809aba87b10105e9a707357a882884a968cab21b538633c58e20642998a" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    bin.install "oksh"
    man1.install "oksh.1"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/oksh -c \"echo hello\"").strip
  end
end
