class Fastbit < Formula
  desc "Open-source data processing library in NoSQL spirit"
  homepage "https://sdm.lbl.gov/fastbit/"
  url "https://code.lbl.gov/frs/download.php/file/426/fastbit-2.0.3.tar.gz"
  sha256 "1ddb16d33d869894f8d8cd745cd3198974aabebca68fa2b83eb44d22339466ec"
  head "https://codeforge.lbl.gov/anonscm/fastbit/trunk",
       :using => :svn

  bottle do
    cellar :any
    sha256 "552fb77c518b46836532889d7b39920200248b59c2403eb48f5391b7979664f0" => :el_capitan
  end

  depends_on "flex" => :build
  depends_on :java
  needs :cxx11

  conflicts_with "iniparser", :because => "Both install `include/dictionary.h`"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    libexec.install lib/"fastbitjni.jar"
    bin.write_jar_script libexec/"fastbitjni.jar", "fastbitjni"
  end

  test do
    assert_equal prefix.to_s,
                 shell_output("#{bin}/fastbit-config --prefix").chomp
    (testpath/"test.csv").write <<-EOS
      Potter,Harry
      Granger,Hermione
      Weasley,Ron
     EOS
    system bin/"ardea", "-d", testpath,
           "-m", "a:t,b:t", "-t", testpath/"test.csv"
  end
end
