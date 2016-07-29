class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://www.bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.3.1.tar.gz"
  sha256 "52beafc9d78fc315115226f31425e21df1714d96c7dfcdeeb02306e2fe028dd8"
  head "https://github.com/bazelbuild/bazel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "58f388a8177e95a1c147cf97c458e41c0e0c0f5cacbf9682a06cc4ef8e1bfbc4" => :el_capitan
    sha256 "c277218891e5b75799462bc4421dc28939e0c61f9d58986456629fa88ba0a4ae" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"

    system "./compile.sh"
    system "./output/bazel", "build", "scripts:bash_completion"

    bin.install "output/bazel" => "bazel"
    bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
    zsh_completion.install "scripts/zsh_completion/_bazel"
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<-EOS.undent
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<-EOS.undent
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system "#{bin}/bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
