class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.17.0/znapzend-0.17.0.tar.gz"
  sha256 "f1fb2090d3e1dc3f5c090def9537ee5308d2b0c88cf97f1c22e14114499fdf48"
  head "https://github.com/oetiker/znapzend.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4e96c4a7dc7f2947d81518a0eff555bf9b7476d6777f99e325a79ad2353d2dbf" => :high_sierra
    sha256 "bb736786f41579488ec440ea6c9a85ee7c8ef6f4d3216a6737d26e3c0d439fc3" => :sierra
    sha256 "8a7ce4e94187a7e51fffeb5779512289dd94731fb76274a19a69002ae085f5b4" => :el_capitan
  end

  depends_on "perl" if MacOS.version <= :mavericks

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<~EOS
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    EOS
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath
    system "#{bin}/znapzendzetup", "list"
    assert_equal <<~EOS, (testpath/"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end
