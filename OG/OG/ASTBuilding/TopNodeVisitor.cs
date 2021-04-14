﻿using System;
using System.Linq;

namespace OG.ASTBuilding
{
    public abstract class TopNodeVisitor<TNode> : OGBaseVisitor<TNode>, ITopNodeable
    {
        public TopNodeVisitor(string topNodeRuleText)
        {
            if (!OGParser.ruleNames.Contains(topNodeRuleText))
            {
                throw new ArgumentException("No such rule name in OGParser ruleNames array");
            }

            TopNode = topNodeRuleText;
        }

        public string TopNode { get; set; }
    }

}