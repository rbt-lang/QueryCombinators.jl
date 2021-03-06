# DataKnots.jl

*DataKnots is a Julia library for querying data with
an extensible, practical and coherent algebra of query
combinators.*

**Documentation** | **Build Status** | **Process**
:---: | :---: | :---:
[![Stable Documentation][doc-rel-img]][doc-rel-url] [![Development Documentation][doc-dev-img]][doc-dev-url] | [![Build Status][ci-img]][ci-url] [![Code Coverage Status][codecov-img]][codecov-url] | [![Chat on Zulip][chat-img]][chat-url] [![Open Issues][issues-img]][issues-url] [![MIT License][license-img]][license-url]

DataKnots is designed to let data analysts and other
accidental programmers query and analyze complex
structured data.

## Showcase

Let's take some Chicago public data and convert it
into a `DataKnot`.

    using DataKnots, CSV

    employee_csv_file = """
        name,department,position,salary
        "JEFFERY A","POLICE","SERGEANT",101442
        "NANCY A","POLICE","POLICE OFFICER",80016
        "JAMES A","FIRE","FIRE ENGINEER-EMT",103350
        "DANIEL A","FIRE","FIRE FIGHTER-EMT",95484
        "BRENDA B","OEMC","TRAFFIC CONTROL AIDE",64392
        """ |> IOBuffer |> CSV.File

    chicago = DataKnot(:employee => employee_csv_file)

We could then query this data to return employees with
salaries greater than their department's average.

    using Statistics: mean

    @query chicago begin
        employee
        group(department)
        keep(avg_salary => mean(employee.salary))
        employee
        filter(salary > avg_salary)
    end
    #=>
      │ employee                                         │
      │ name       department  position           salary │
    ──┼──────────────────────────────────────────────────┼
    1 │ JAMES A    FIRE        FIRE ENGINEER-EMT  103350 │
    2 │ JEFFERY A  POLICE      SERGEANT           101442 │
    =#

In this example, nouns, such as `employee`, `department` and
`salary`, are *query primitives*. The verbs, such as `group`,
`keep`, `mean` and `filter` are *query combinators*. Query
expressions, such as `group(department)`, are built from
existing queries by applying these combinators.

Queries could also be constructed with pure Julia code,
without using macros. The query above could be
equivalently written:

    using Statistics: mean

    chicago[It.employee >>
            Group(It.department) >>
            Keep(:avg_salary => mean.(It.employee.salary)) >>
            It.employee >>
            Filter(It.salary .> It.avg_salary)]
    #=>
      │ employee                                         │
      │ name       department  position           salary │
    ──┼──────────────────────────────────────────────────┼
    1 │ JAMES A    FIRE        FIRE ENGINEER-EMT  103350 │
    2 │ JEFFERY A  POLICE      SERGEANT           101442 │
    =#

## Objectives

DataKnots implements an algebraic query interface of
[Query Combinators]. This algebra’s elements, or queries,
represent relationships among class entities and data
types. This algebra’s operations, or combinators, are
applied to construct query expressions.

We seek to prove that this query algebra has
significant advantages over the state of the art:

* DataKnots is a practical alternative to SQL with
  a declarative syntax; this makes it suitable for
  use by domain experts.

* DataKnots' data model handles nested and recursive
  structures (unlike DataFrames or SQL); this makes
  it suitable for working with CSV, JSON, XML, and
  SQL databases.

* DataKnots has a formal semantic model based upon
  monadic composition; this makes it easy to reason
  about the structure and interpretation of queries.

* DataKnots is a combinator algebra (like XPath but
  unlike LINQ or SQL); this makes it easier to assemble
  queries dynamically.

* DataKnots is fully extensible with Julia; this makes
  it possible to specialize it into various domain
  specific query languages.

## Support

At this time, while we welcome feedback and contributions,
DataKnots is not yet usable for general audiences.

Our development chat is currently hosted on Zulip:
https://julialang.zulipchat.com/#narrow/stream/247484-dataknots.2Ejl

Current documentation could be found at:
https://mechanicalrabbit.github.io/DataKnots.jl/stable/


[ci-img]: https://github.com/MechanicalRabbit/DataKnots.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/MechanicalRabbit/DataKnots.jl/actions?query=workflow%3ACI+branch%3Amaster
[codecov-img]: https://codecov.io/gh/MechanicalRabbit/DataKnots.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/MechanicalRabbit/DataKnots.jl
[issues-img]: https://img.shields.io/github/issues/MechanicalRabbit/DataKnots.jl.svg
[issues-url]: https://github.com/MechanicalRabbit/DataKnots.jl/issues
[doc-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[doc-rel-img]: https://img.shields.io/badge/docs-stable-green.svg
[doc-dev-url]: https://mechanicalrabbit.github.io/DataKnots.jl/dev/
[doc-rel-url]: https://mechanicalrabbit.github.io/DataKnots.jl/stable/
[license-img]: https://img.shields.io/badge/license-MIT-brightgreen.svg
[license-url]: https://raw.githubusercontent.com/MechanicalRabbit/DataKnots.jl/master/LICENSE.md
[chat-img]: https://img.shields.io/badge/chat-julia--zulip-blue
[chat-url]: https://julialang.zulipchat.com/#narrow/stream/247484-dataknots.2Ejl
[Query Combinators]: https://arxiv.org/abs/1702.08409
