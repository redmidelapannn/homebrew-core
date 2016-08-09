class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://www.bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.3.1.tar.gz"
  sha256 "52beafc9d78fc315115226f31425e21df1714d96c7dfcdeeb02306e2fe028dd8"
  head "https://github.com/bazelbuild/bazel.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "72f59813f83be73fcf060119aaeb1f7675a0778eadc3e432008d1897482e64f4" => :el_capitan
    sha256 "df9edf461af32e3c1773e83739a0e5e4d3bafe02ec53177906574e23184d8e8e" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    system "./compile.sh"
    system "./output/bazel", "--output_user_root", buildpath/"output_user_root",
           "build", "scripts:bash_completion"

    bin.install "scripts/packages/bazel.sh" => "bazel"
    bin.install "output/bazel" => "bazel-real"
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

    system bin/"bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
