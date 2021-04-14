﻿using System.Collections.Generic;
using OG.ASTBuilding.TreeNodes.BoolNodes_and_extractors;
using OG.ASTBuilding.TreeNodes.TerminalNodes;

namespace OG.ASTBuilding.TreeNodes.FunctionCalls
{
    public class BoolFunctionCallNode : BoolTerminalNode, IFunctionCallNode
    {
        public BoolFunctionCallNode(string value, IdNode id, List<ParameterNode> parameters) : base(value, BoolType.FunctionCallNode)
        {
            FunctionName = id;
            Parameters = parameters;
        }

        public IdNode FunctionName { get; set; }
        public List<ParameterNode> Parameters { get; set; }
    }
}