class Dbacl < Formula
  desc "Digramic Bayesian classifier"
  homepage "https://dbacl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dbacl/dbacl/1.14.1/dbacl-1.14.1.tar.gz"
  sha256 "ff0dfb67682e863b1c3250acc441ce77c033b9b21d8e8793e55b622e42005abd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6effe73086dabdf61c584f88275b86b512d4a85e02612cd6ef7318b2e83ddf5c" => :mojave
    sha256 "abdde448f6354be6f05b6d61b5a3e2e391182e8f706d52d1397e021552ca4209" => :high_sierra
    sha256 "f9bd9ab031463d6fac0b811f47bb1758d2af474f82cdeebd8db83e5d3a73ce0f" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"mark-twain.txt").write <<~EOS
      The report of my death was an exaggeration.
      The secret of getting ahead is getting started.
      Travel is fatal to prejudice, bigotry, and narrow-mindedness.
      I have never let my schooling interfere with my education.
      Whenever you find yourself on the side of the majority, it is time to pause and reflect.
      Kindness is the language which the deaf can hear and the blind can see.
      The two most important days in your life are the day you are born and the day you find out why.
      Truth is stranger than fiction, but it is because Fiction is obliged to stick to possibilities; Truth isn't.
      If you tell the truth, you don't have to remember anything.
      It's not the size of the dog in the fight, it's the size of the fight in the dog.
    EOS

    (testpath/"william-shakespeare.txt").write <<~EOS
      Hell is empty and all the devils are here.
      All that glitters is not gold
      To thine own self be true, and it must follow, as the night the day, thou canst not then be false to any man.
      Love all, trust a few, do wrong to none.
      To be, or not to be, that is the question
      Be not afraid of greatness: some are born great, some achieve greatness, and some have greatness thrust upon them.
      The lady doth protest too much, methinks.
      So full of artless jealousy is guilt, It spills itself in fearing to be spilt.
      If music be the food of love, play on.
      There is nothing either good or bad, but thinking makes it so.
      The course of true love never did run smooth.
    EOS

    system "#{bin}/dbacl", "-l", "twain", "mark-twain.txt"
    system "#{bin}/dbacl", "-l", "shake", "william-shakespeare.txt"

    output = pipe_output("#{bin}/dbacl -v -c twain -c shake", "to be or not to be")
    assert_equal "shake", output.strip
  end
end
