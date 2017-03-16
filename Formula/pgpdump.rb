class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.31.tar.gz"
  sha256 "7abf04a530c902cfb1f1a81c6b5fb88bd2c12b5f3c37dceb1245bfe28f2a7c0b"
  head "https://github.com/kazu-yamamoto/pgpdump.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d9fd9b656f3ca9cfee9d8f4b46b8cd7d79e771f7396df0e49a87653a1e3a1186" => :sierra
    sha256 "165eed30ab07cb62fef3af7772895ee4dc87bc474f46e7315b6b07efa82c7a4a" => :el_capitan
    sha256 "092f7d4264e3077cf9f16a355ad58007d9512b0b531fc1b0e5d90207928b726a" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"sig.pgp").write <<-EOS.undent
      -----BEGIN PGP MESSAGE-----
      Version: GnuPG v1.2.6 (NetBSD)
      Comment: For info see https://www.gnupg.org

      owGbwMvMwCSYq3dE6sEMJU7GNYZJLGmZOanWn4xaQzIyixWAKFEhN7W4ODE9VaEk
      XyEpVaE4Mz0vNUUhqVIhwD1Aj6vDnpmVAaQeZogg060chvkFjPMr2CZNmPnwyebF
      fJP+td+b6biAYb779N1eL3gcHUyNsjliW1ekbZk6wRwA
      =+jUx
      -----END PGP MESSAGE-----
    EOS

    output = shell_output("#{bin}/pgpdump sig.pgp")
    assert_match("Key ID - 0x6D2EC41AE0982209", output)
  end
end
