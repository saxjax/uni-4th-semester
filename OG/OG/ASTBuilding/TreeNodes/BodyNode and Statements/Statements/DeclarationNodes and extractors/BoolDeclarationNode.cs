﻿using OG.ASTBuilding.TreeNodes.BoolNodes_and_extractors;
using OG.ASTBuilding.TreeNodes.TerminalNodes;

namespace OG.ASTBuilding.TreeNodes.BodyNode_and_Statements.Statements.DeclarationNodes_and_extractors
{
    public class BoolDeclarationNode : DeclarationNode
    {
        public BoolDeclarationNode(IdNode id, BoolNode assignmentAssignedExpression):base(id, assignmentAssignedExpression, DeclarationType.BoolDeclarationNode)
        {
            Id = id;
            AssignedExpression = assignmentAssignedExpression;
        }
    }
}