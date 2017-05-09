class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.6.0.tar.gz"
  sha256 "b4d9c5d8825fc23981c7a85e62ac92a4635b26186d229bc382de3cfccb8373df"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbdca8d2d80fb2c96f31d15739a790fb96804c9ef8aa535104348d02c8ede0dd" => :sierra
    sha256 "7e8c22f8662da1ac65844ea989f74595584fe6d51eb436569e5f6dde79944b06" => :el_capitan
    sha256 "1fd5792558cba09a698520a5dd6e357efa6806de2fb5a2004c288d2566f82ed4" => :yosemite
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
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
