﻿using OG.ASTBuilding.TreeNodes.MathNodes_and_extractors;
using CoordinateXyValueNode = OG.ASTBuilding.TreeNodes.BodyNodesAndVisitors.CoordinateXyValueNode;

namespace OG.ASTBuilding.TreeNodes.BodyNode_and_Statements.Statements.AssignmentNodes_and_extractors
{
    public class PropertyAssignmentNode : AssignmentNode
    {
        public MathNode assignedValue { get; set; }
        public CoordinateXyValueNode coordinateValueNode { get; set; }

        public PropertyAssignmentNode(CoordinateXyValueNode xyValue, MathNode value) : base(xyValue.Id, AssignmentType.PropertyAssignmentNode)
        {
            assignedValue =  value;
            this.coordinateValueNode = xyValue;
        }
    }
}