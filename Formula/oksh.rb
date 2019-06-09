class Oksh < Formula
  desc "Portable OpenBSD Korn Shell"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-6.5/oksh-6.5.tar.gz"
  sha256 "2adf52ab718249462a41e1172d0bfb8670731daa0618e560be58064cac23a0bd"

  head "https://github.com/ibara/oksh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9abf6ee14cbd997bb052171db8875260f0cbfdc0ad45e921d9924c058ff382cc" => :mojave
    sha256 "009fc7998ca23617ba13d0e1a68ffe96a41bcdfdfbd701900c22dbef34606bbd" => :high_sierra
    sha256 "3593b4c6e1aeea9295c9b83edbb5ff3a4373af8239746475154cd7fdd20db874" => :sierra
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-curses
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "42", shell_output("#{bin}/oksh -c 'printf 42'").strip
  end
end
