class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.janelia.org"
  bottle do
    cellar :any_skip_relocation
    sha256 "5eaa5cadbc4c79e36f0d2e832835b9d14cf63ab846af09f697453ed43065bb4c" => :high_sierra
    sha256 "5f78176d59dc103db4e9d043cbd3cdd304e902b4563ed80bc5f08a444f6aaa2c" => :sierra
    sha256 "e1bca630986b195e8138aeaf058caf8d146b3e839f2c3679e8e012185a764ce6" => :el_capitan
  end

  # doi "10.1371/journal.pcbi.1002195"
  # tag "bioinformatics"

  url "http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz"
  sha256 "dd16edf4385c1df072c9e2f58c16ee1872d855a018a2ee6894205277017b5536"

  head do
    url "https://svn.janelia.org/eddylab/eddys/src/hmmer/trunk"
    depends_on "autoconf" => :build
  end

  option "without-test", "Skip build-time tests (not recommended)"

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    # Installing libhmmer.a causes trouble for infernal.
    # See https://github.com/Homebrew/homebrew-science/issues/1931
    libexec.install lib/"libhmmer.a", include

    doc.install "Userguide.pdf", "tutorial"
  end

  test do
    assert_match "PF00069.17", shell_output("#{bin}/hmmstat #{doc}/tutorial/minifam")
  end
end
