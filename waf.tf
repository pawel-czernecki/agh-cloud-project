resource "aws_wafv2_web_acl" "waf" {
  name  = "app-waf"
  scope = "REGIONAL"
  default_action {
    allow {}
  }
  rule {
    name     = "aws-managed-rules-common-rule-set"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "aws-managed-rules-common-rule-set"
      sampled_requests_enabled   = true
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "app-waf-metrics"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "waf_assoc" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}