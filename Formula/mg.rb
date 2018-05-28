class Mg < Formula
  desc "Small Emacs-like editor"
  # https://devio.us/~bcallah/mg/ is temporarily offline
  homepage "https://github.com/ibara/mg"
  # https://devio.us/~bcallah/mg/mg-20180421.tar.gz is temporarily offline
  url "https://dl.bintray.com/homebrew/mirror/mg-20180421.tar.gz"
  sha256 "11215613a360cf72ff16c2b241ea4e71b4b80b2be32c62a770c1969599e663b2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "62e0b2eadfe5f0d527bd166744c06ecfb34f285975385ea5c5ac9648d9b3bbe2" => :high_sierra
    sha256 "bfad004de6310f0951b78c5cd0b39c0b4139b2847f42506a778adeea68ef41e2" => :sierra
    sha256 "f4413ac4121249725f199512cc516b4da3c66c316d38f0d46539c4a1aeb28c17" => :el_capitan
  end

  depends_on :macos => :yosemite # older versions don't support fstatat(2)

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"command.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system testpath/"command.sh"
  end
end
