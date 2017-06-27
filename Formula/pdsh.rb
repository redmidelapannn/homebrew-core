class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://code.google.com/p/pdsh/"
  url "https://github.com/grondo/pdsh/releases/download/pdsh-2.32/pdsh-2.32.tar.gz"
  sha256 "e1f1e5421d144a80ffc93fbdd5ace739fc39eb3219bd71d2ac06cf436428ef57"

  bottle do
    sha256 "920c259f9a92684066f011e003696b810cadd93d76005dd769d41227b23343eb" => :sierra
    sha256 "dfa35476c0c5efb55e150cb45286156a9e991584669771d84684288450e4ebdc" => :el_capitan
    sha256 "6d73f8829c0a7511896008824b77a9477b8934a2920815a4a22d804e7b3e16b4" => :yosemite
  end

  option "without-dshgroups", "This option should be specified to load genders module first"

  depends_on "readline"
  depends_on "genders" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssh
      --without-rsh
      --with-nodeupdown
      --with-readline
      --without-xcpu
    ]

    args << "--with-genders" if build.with? "genders"
    args << (build.without?("dshgroups") ? "--without-dshgroups" : "--with-dshgroups")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pdsh", "-V"
  end
end
