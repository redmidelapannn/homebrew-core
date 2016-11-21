class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/v0.5.0.tar.gz"
  sha256 "c20ee39bd8f519f874de3d1bc9dc65fb6430606d80badf34e070cc8a2225b62b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a45c720878941ef7a119b217ee716d875c886ef8f2db43a58ce670a1c33bb93d" => :sierra
    sha256 "82591e8a056f6eb227e791c79ca597a1f787e6a1ee3b6718117614643e7b5d5d" => :el_capitan
    sha256 "68fb8fa59e2c4aab383cdfcbceb1ce2a937fe673a681deb98bf96937d0950799" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    libexec.install "dump_json_ast"
  end

  test do
    sample_query = <<-EOS.undent
      { user }
    EOS

    sample_ast = { "kind"=>"Document",
                   "loc"=>{ "start"=>1, "end"=>9 },
                   "definitions"=>
        [{ "kind"=>"OperationDefinition",
           "loc"=>{ "start"=>1, "end"=>9 },
           "operation"=>"query",
           "name"=>nil,
           "variableDefinitions"=>nil,
           "directives"=>nil,
           "selectionSet"=>
           { "kind"=>"SelectionSet",
             "loc"=>{ "start"=>1, "end"=>9 },
             "selections"=>
             [{ "kind"=>"Field",
                "loc"=>{ "start"=>3, "end"=>7 },
                "alias"=>nil,
                "name"=>
                { "kind"=>"Name", "loc"=>{ "start"=>3, "end"=>7 }, "value"=>"user" },
                "arguments"=>nil,
                "directives"=>nil,
                "selectionSet"=>nil }] } }] }

    test_ast = JSON.parse pipe_output("#{libexec}/dump_json_ast", sample_query)
    assert_equal sample_ast, test_ast
  end
end
