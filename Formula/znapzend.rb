class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.17.0/znapzend-0.17.0.tar.gz"
  sha256 "f1fb2090d3e1dc3f5c090def9537ee5308d2b0c88cf97f1c22e14114499fdf48"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2ad002d71c4c950bd1dfca7969509848387174f1a985bbd15fe0d30dc2077997" => :high_sierra
    sha256 "4a6227c355922b75fd2396bbb66b91d6f31836cc49c36bc6475f1f6da77fd07c" => :sierra
    sha256 "9c3102df600eabe8942384ea371241e2204eba71e87e385bb617b137885520ec" => :el_capitan
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
