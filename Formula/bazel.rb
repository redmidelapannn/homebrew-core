class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.21.0/bazel-0.21.0-dist.zip"
  sha256 "6ccb831e683179e0cfb351cb11ea297b4db48f9eab987601c038aa0f83037db4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3b627584f158dab8eba7049d63b7f41d6ee1e639db05c01227cb25f4c43e05a" => :mojave
    sha256 "d7d003a5d9a28a1ec45ac46a28cd103d8f753d8e1f97e2a3bfcf299cf61a8231" => :high_sierra
    sha256 "ad1d3be88d9b6780cc642368fd41611388ab948b86a257693bba65904a03229a" => :sierra
  end

  depends_on :java => "1.8"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel",
             "--output_user_root",
             buildpath/"output_user_root",
             "build",
             "--java_toolchain=@bazel_tools//tools/jdk:toolchain_hostjdk8",
             "--host_java_toolchain=@bazel_tools//tools/jdk:toolchain_hostjdk8",
             "--host_javabase=@bazel_tools//tools/jdk:jdk",
             "--javabase=@bazel_tools//tools/jdk:jdk",
             "scripts:bash_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      bin.install "output/bazel" => "bazel-real"
      bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
      zsh_completion.install "scripts/zsh_completion/_bazel"

      prefix.install_metafiles
    end
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

    system bin/"bazel",
           "build",
           "--host_java_toolchain=@bazel_tools//tools/jdk:toolchain_hostjdk8",
           "--java_toolchain=@bazel_tools//tools/jdk:toolchain_hostjdk8",
           "//:bazel-test"
    assert_equal "Hi!\n", pipe_output("bazel-bin/bazel-test")
  end
end
