class BazelAT0701 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.7.0/bazel-0.7.0-dist.zip"
  sha256 "a084a9c5d843e2343bf3f319154a48abe3d35d52feb0ad45dec427a1c4ffc416"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "fda7734fa17be4f0b4b49bf431a58f811e73b0d5df99cf4f79df172ab737b1ca" => :high_sierra
    sha256 "a2c1ab04fcdfd164581015104ffe4732c5c739a799a0889b5d5ff41d572418fb" => :sierra
    sha256 "8544bc5b1ff35f5936aa710a5629a05acf40095cb52ccca05315d991c53f6666" => :el_capitan
  end

  keg_only :versioned_formula
  depends_on :java => "1.8"
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
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))

    bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
    zsh_completion.install "scripts/zsh_completion/_bazel"
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<~EOS
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<~EOS
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
