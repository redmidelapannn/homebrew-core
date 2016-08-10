class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.3.7.tar.gz"
  sha256 "5695c81f795ec46ee1dfa7fd8a895a1bb8dfe087748a9da7b4b2c8d877323a45"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "afbf934b2605afa4f11920ba4112098cfad1dbb031da743f90f99c13bbad2a6b" => :el_capitan
    sha256 "03fea4101a7ccb876aaec2a1d6af867b552d5a9682cb7da513da3996a8a5cf7c" => :yosemite
    sha256 "bc6c694efde7e8d1d39e87efb8cd034fc676f00b36d28090269c75e708e8d393" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install bitrise
    bitrise_go_path = buildpath/"src/github.com/bitrise-io/bitrise"
    bitrise_go_path.install Dir["*"]

    cd bitrise_go_path do
      prefix.install_metafiles

      system "go", "build", "-o", bin/"bitrise"
    end
  end

  test do
    (testpath/"bitrise.yml").write <<-EOS.undent
      format_version: 1.1.0
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    # setup
    system "#{bin}/bitrise", "setup"
    # run the defined test_wf workflow
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
