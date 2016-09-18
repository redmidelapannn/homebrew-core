require "language/node"

class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://registry.npmjs.org/diff-so-fancy/-/diff-so-fancy-0.11.1.tgz"
  sha256 "c2824f4661d706ef9af7317fc253c123bc8f5d88f83732d880c4504309ae7a0f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cb12f70487728abbf0f2ad8213ac7372bf0e0e5bf9c101d35ecd17f9e0e3e088" => :sierra
    sha256 "8d0fc2f2775ef32d9e9c6c33c0de7c0f1add85da91cb43750036887d9837595e" => :el_capitan
    sha256 "0a8884ac085b1f25081c68fe2f1a2eb0c2e582195bd2e711d8fc6d739b1287f8" => :yosemite
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    diff = <<-EOS.undent
      diff --git a/hello.c b/hello.c
      index 8c15c31..0a9c78f 100644
      --- a/hello.c
      +++ b/hello.c
      @@ -1,5 +1,5 @@
       #include <stdio.h>

       int main(int argc, char **argv) {
      -    printf("Hello, world!\n");
      +    printf("Hello, Homebrew!\n");
       }
    EOS
    assert_match "modified: hello.c", pipe_output(bin/"diff-so-fancy", diff, 0)
  end
end
