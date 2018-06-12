class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.10.0.tar.gz"
  sha256 "5c77d0dab496489d1418d562a4ef90710f9ff70628a35e6089269605788953df"
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c1c098484506be3f37bd80bd9a4689853b7a651ec2e85e7b437d494c261c218" => :high_sierra
    sha256 "ec9a053170ea039119f7b995675162b67373cc8680349f5319dbd6b1d23b3e21" => :sierra
    sha256 "979c5e76847dce9a91b8a3f19a0cef3d4c5057223b7b3b004f86f5d6d90e6f0e" => :el_capitan
  end

  depends_on "ant" => :build
  depends_on :java => "1.7+"

  def install
    system "ant", "linux"
    libexec.install Dir["release/Linux/BEASTv*/*"]
    pkgshare.install_symlink libexec/"examples"
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    cp pkgshare/"examples/clockModels/testUCRelaxedClockLogNormal.xml", testpath

    # Run fewer generations to speed up tests
    inreplace "testUCRelaxedClockLogNormal.xml", 'chainLength="10000000"',
                                                 'chainLength="100000"'

    system "#{bin}/beast", "-beagle_off", "testUCRelaxedClockLogNormal.xml"

    %w[ops log trees].each do |ext|
      output = "testUCRelaxedClockLogNormal." + ext
      assert_predicate testpath/output, :exist?, "Failed to create #{output}"
    end
  end
end
