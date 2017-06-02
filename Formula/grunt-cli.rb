require "language/node"

class GruntCli < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.2.0.tgz"
  sha256 "fdb1d4bd83435b3f70614b608e0027a0d75ebfda151396bb99c46405334a01d8"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5149cecaaa43a59399ead60a8e152f3d53162ca5a51fe1b63c4f378f765cb34e" => :sierra
    sha256 "ecdb87c9eede4ff70c7655aa06d92b9c309528ba8ffc4d456cc47f74ce30f429" => :el_capitan
    sha256 "eae14032bb1fa1e6a26f5cd5816032c32a33b7c2a0e4bcb81d22b8406dbd55c0" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<-EOS.undent
    {
      "name": "grunt-homebrew-test",
      "version": "1.0.0",
      "devDependencies": {
        "grunt": ">=0.4.0"
      }
    }
    EOS

    (testpath/"Gruntfile.js").write <<-EOS.undent
    module.exports = function(grunt) {
      grunt.registerTask("default", "Write output to file.", function() {
        grunt.file.write("output.txt", "Success!");
      })
    };
    EOS

    system "npm", "install", *Language::Node.local_npm_install_args
    system bin/"grunt"
    assert File.exist?("output.txt"), "output.txt was not generated"
  end
end
