class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "http://www.scala-sbt.org"
  url "https://dl.bintray.com/sbt/native-packages/sbt/0.13.11/sbt-0.13.11.tgz"
  sha256 "a36a6fbf6dd70afd93fb8db16c40e8ac00798fdddfa0b4c678786dc15617afa6"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "cfa0a517b56a0156556fef371f340705fddb5b2fe6bfb89307096191be7459bc" => :el_capitan
    sha256 "f769c3e132bc4a52c915cfc91e70900ca6b2a2441069c67b2fc7eda82ec35940" => :yosemite
    sha256 "f57e7c2bc4810dc40b737e202ca49439d8f61afd86c68fd86d6ef22eebd3e45c" => :mavericks
  end

  depends_on :java => "1.6+"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="${sbt_home}/conf/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    inreplace "bin/sbt-launch-lib.bash", "${sbt_home}/bin/sbt-launch.jar", "#{libexec}/sbt-launch.jar"

    libexec.install "bin/sbt", "bin/sbt-launch-lib.bash", "bin/sbt-launch.jar"
    etc.install "conf/sbtopts"

    (bin/"sbt").write <<-EOS.undent
      #!/bin/sh
      if [ -f "$HOME/.sbtconfig" ]; then
        echo "Use of ~/.sbtconfig is deprecated, please migrate global settings to #{etc}/sbtopts" >&2
        . "$HOME/.sbtconfig"
      fi
      exec "#{libexec}/sbt" "$@"
    EOS
  end

  def caveats;  <<-EOS.undent
    You can use $SBT_OPTS to pass additional JVM options to SBT:
       SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

    This formula is now using the standard typesafe sbt launcher script.
    Project specific options should be placed in .sbtopts in the root of your project.
    Global settings should be placed in #{etc}/sbtopts
    EOS
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Dsbt.log.noformat=true"
    ENV.java_cache
    output = shell_output("#{bin}/sbt sbt-version")
    assert_match "[info] #{version}", output
  end
end
