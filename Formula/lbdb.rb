class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.41.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/lbdb/lbdb_0.41.tar.xz"
  sha256 "fc9261cdc361d95e33da08762cafe57f8b73ab2598f9073986f0f9e8ad64a813"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "051ef55619c9bde822984dd40db7b87e72865c2862211e63e73237a4233974bf" => :el_capitan
    sha256 "c2e6905f8c0913bb191ad60909a2006dc28b0c280d6f1c867a44e5a631b70c95" => :yosemite
    sha256 "4c3979ccffe5aff5f3cd03f8f46a46c61e3b2987425de3937f447074e1138efe" => :mavericks
  end

  depends_on "gnupg" => :optional
  depends_on "abook" => :recommended

  deprecated_option "with-gpg" => "with-gnupg"

  def install
    args = %W[
      --prefix=#{prefix}
      --libdir=#{libexec}
    ]
    args << "--with-gpg" if build.with? "gnupg"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
