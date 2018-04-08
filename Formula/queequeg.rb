class Queequeg < Formula
  desc "English grammar checker for non-native speakers"
  homepage "https://queequeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/queequeg/queequeg/queequeg-0.91/queequeg-0.91.tar.gz"
  sha256 "44e2f2bb8b68d08b7ee95ece24cefeeea8ec6ff9150851922015b73fc8908136"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4ed5771e115c653a8cd2087fe506c2919bca4d146a708157d31e738e206d7831" => :high_sierra
    sha256 "4ed5771e115c653a8cd2087fe506c2919bca4d146a708157d31e738e206d7831" => :sierra
    sha256 "4ed5771e115c653a8cd2087fe506c2919bca4d146a708157d31e738e206d7831" => :el_capitan
  end

  depends_on "python@2"
  depends_on "wordnet"

  def install
    system "make", "dict", "WORDNETDICT=#{Formula["wordnet"].opt_prefix}/dict"

    libexec.install "abstfilter.py", "constraint.py", "convdict.py",
                    "dictionary.py", "document.py",
                    "grammarerror.py", "markupbase_rev.py", "output.py",
                    "postagfix.py", "pstring.py", "qq", "regpat.py",
                    "sentence.py", "sgmllib_rev.py", "texparser.py",
                    "unification.py"

    if File.exist? "dict.cdb"
      libexec.install "dict.cdb"
    else
      libexec.install "dict.txt"
    end

    bin.write_exec_script "#{libexec}/qq"
  end

  test do
    (testpath/"filename").write "This is a test."
    system "#{bin}/qq", "#{testpath}/filename"
  end
end
