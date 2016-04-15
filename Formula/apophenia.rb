class Apophenia < Formula
  desc "C library for statistical and scientific computing"
  homepage "http://apophenia.info/"
  url "https://github.com/b-k/apophenia/archive/v1.0.tar.gz"
  sha256 "c753047a9230f9d9e105541f671c4961dc7998f4402972424e591404f33b82ca"

  bottle do
    cellar :any
    sha256 "24eac72416c7f9646e3a1f310cadcd96e74d5bbcfdc7c2f3d2b6b89fd275d3a3" => :el_capitan
    sha256 "c2c65476f1c93f931fe2400642624389e1658a6843018ed1edb8aee90f2b85f9" => :yosemite
    sha256 "91e5a522379bc0f798d85385dc5d96685c5de557c1dd42d52af4d7fd9532855e" => :mavericks
  end

  depends_on "gsl"
  depends_on "sqlite"

  def install
    system "./configure", "--with-mysql=no", "--enable-extended-tests", "--prefix=#{prefix}"
    system "make", "-j"
    system "make", "install"
  end

  test do
    # write a sample csv text file to import
    (testpath/"foo.csv").write <<-EOS.undent
      thud,bump
      1,2
      3,4
      5,6
      7,8
    EOS
    # test the csv to sqlite importer (built with libapophenia) works
    system "#{bin}/apop_text_to_db", (testpath/"foo.csv"), "bar", (testpath/"baz.db")
    system "echo", ".dump", "bar", "|", "sqlite3", (testpath/"baz.db")
    # test the graph plotting tool (built with libapophenia) works
    system "#{bin}/apop_plot_query", "-d", (testpath/"baz.db"), "-q", "select thud,bump from bar", "-f", "grumble"
  end
end
